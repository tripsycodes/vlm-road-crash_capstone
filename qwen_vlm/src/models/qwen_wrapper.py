"""
Wrapper for Qwen-VL model integration.
Supports Qwen2-VL and Qwen-VL-Chat models.
"""

import torch
from typing import List, Dict, Any
from PIL import Image
import numpy as np


class QwenVLWrapper:
    def __init__(self, model_name: str = "Qwen/Qwen2-VL-7B-Instruct",
                 device: str = "cuda"):
        self.model_name = model_name
        self.device = device
        self.model = None
        self.processor = None
        self._load_model()

    def _load_model(self):
        from transformers import Qwen2VLProcessor, Qwen2VLForConditionalGeneration

        # Try to import BitsAndBytesConfig
        try:
            from transformers import BitsAndBytesConfig
        except ImportError:
            BitsAndBytesConfig = None

        if self.device == "cuda" and torch.cuda.is_available():
            # Clear cache aggressively before loading
            torch.cuda.empty_cache()
            import gc
            gc.collect()
            torch.cuda.empty_cache()
            
            # Get the actual device (respects CUDA_VISIBLE_DEVICES)
            device_id = torch.cuda.current_device()
            device_str = f"cuda:{device_id}"
            
            # Get available memory
            free_memory = None
            if torch.cuda.is_available():
                total_memory = torch.cuda.get_device_properties(device_id).total_memory / 1e9
                allocated = torch.cuda.memory_allocated(device_id) / 1e9
                reserved = torch.cuda.memory_reserved(device_id) / 1e9
                free_memory = total_memory - reserved
                print(f"GPU {device_id} - Total: {total_memory:.2f}GB, Reserved: {reserved:.2f}GB, Free: {free_memory:.2f}GB")
            
            model_dtype = torch.float16
            use_device_map = True
            
            # Use 4-bit quantization for maximum memory efficiency (Qwen-VL is large)
            quantization_config = None
            use_quantization = False
            try:
                import bitsandbytes as bnb
                if BitsAndBytesConfig is None:
                    raise ImportError("BitsAndBytesConfig not available in transformers")
                use_quantization = True
                # Use 4-bit quantization to save more memory
                quantization_config = BitsAndBytesConfig(
                    load_in_4bit=True,
                    bnb_4bit_compute_dtype=torch.float16,
                    bnb_4bit_use_double_quant=True,
                    bnb_4bit_quant_type="nf4"
                )
                print("Using 4-bit quantization for maximum memory efficiency")
            except ImportError:
                print("bitsandbytes not available, trying 8-bit...")
                # Fallback to 8-bit if 4-bit fails
                try:
                    quantization_config = BitsAndBytesConfig(
                        load_in_8bit=True,
                        llm_int8_threshold=6.0,
                        llm_int8_has_fp16_weight=False
                    )
                    use_quantization = True
                    print("Using 8-bit quantization with stability optimizations")
                except:
                    print("8-bit also failed, using FP16")
                    use_quantization = False
            except Exception as e:
                print(f"4-bit quantization setup failed: {e}, trying 8-bit...")
                try:
                    quantization_config = BitsAndBytesConfig(
                        load_in_8bit=True,
                        llm_int8_threshold=6.0,
                        llm_int8_has_fp16_weight=False
                    )
                    use_quantization = True
                    print("Using 8-bit quantization as fallback")
                except:
                    print("All quantization failed, using FP16")
                    use_quantization = False
        else:
            device_str = "cpu"
            model_dtype = torch.float32
            use_device_map = False
            use_quantization = False
            quantization_config = None
            free_memory = None
            device_id = None

        try:
            print(f"Loading Qwen-VL model: {self.model_name}...")
            
            # Load processor
            self.processor = Qwen2VLProcessor.from_pretrained(self.model_name)
            
            # Load model with proper configuration
            load_kwargs = {
                "torch_dtype": model_dtype,
                "low_cpu_mem_usage": True
            }

            if use_device_map:
                if use_quantization and quantization_config is not None:
                    load_kwargs["quantization_config"] = quantization_config
                    load_kwargs.pop("torch_dtype", None)
                    load_kwargs["device_map"] = device_str
                    quant_type = "4-bit" if quantization_config.load_in_4bit else "8-bit"
                    print(f"Loading model to {device_str} with {quant_type} quantization...")
                else:
                    load_kwargs["device_map"] = device_str
                    print(f"Loading model directly to {device_str}...")

            self.model = Qwen2VLForConditionalGeneration.from_pretrained(
                self.model_name, **load_kwargs
            )

            # If device_map was used, model is already on device
            if not use_device_map and self.device != "cpu":
                print(f"Moving model to {device_str}...")
                self.model = self.model.to(device_str)

            self.device = device_str
            print(f"✓ Loaded Qwen-VL model: {self.model_name} on {self.device}")
            
            # Clear cache after loading
            if torch.cuda.is_available():
                torch.cuda.empty_cache()

        except Exception as e:
            print(f"Failed to load Qwen-VL model: {str(e)[:500]}")
            raise RuntimeError(f"Could not load Qwen-VL model. Error: {str(e)[:500]}")

    # ------------------------------------------------------------------
    def encode_frames(self, frames: List[np.ndarray]) -> Dict[str, torch.Tensor]:
        """Encode frames for model input."""
        images = [Image.fromarray(f).convert("RGB") for f in frames]
        inputs = self.processor(images=images, return_tensors="pt")
        return {k: v.to(self.device) if isinstance(v, torch.Tensor) else v 
                for k, v in inputs.items()}

    # ------------------------------------------------------------------
    def generate_caption(self, frames: List[np.ndarray], prompt: str) -> str:
        """Generate caption from frames and prompt."""
        if len(frames) == 0:
            raise ValueError("No frames provided")

        # Use middle frame (for now)
        rep = frames[len(frames) // 2]
        rep_img = Image.fromarray(rep).convert("RGB")

        # Qwen-VL uses a different prompt format
        # Format: messages with role and content
        messages = [
            {
                "role": "user",
                "content": [
                    {"type": "image", "image": rep_img},
                    {"type": "text", "text": prompt}
                ]
            }
        ]

        # Prepare inputs
        text = self.processor.apply_chat_template(
            messages, tokenize=False, add_generation_prompt=True
        )
        image_inputs, video_inputs = self.processor.process_vision_info(messages)

        inputs = self.processor(
            text=[text],
            images=image_inputs,
            videos=video_inputs,
            padding=True,
            return_tensors="pt"
        )
        inputs = {k: v.to(self.device) if isinstance(v, torch.Tensor) else v 
                 for k, v in inputs.items()}

        with torch.no_grad():
            outputs = self.model.generate(
                **inputs,
                max_new_tokens=512,
                do_sample=False
            )

        # Decode response
        response = self.processor.batch_decode(
            outputs, skip_special_tokens=True, clean_up_tokenization_spaces=False
        )[0]
        
        # Extract assistant response
        if "assistant" in response.lower():
            parts = response.split("assistant", 1)
            if len(parts) > 1:
                response = parts[-1].strip()
        
        return response

    # ------------------------------------------------------------------
    def generate_summary(self, frames: List[np.ndarray],
                         task_type: str = "v2t") -> Dict[str, Any]:
        """Generate summary from frames."""
        if task_type == "v2t":
            summary_prompt = (
                "You are an expert traffic accident analyst. "
                "Watch this car crash video and generate a factual explanation. "
                "Describe clearly:\n"
                "- vehicles involved\n"
                "- number of vehicles\n"
                "- what each vehicle was doing before the crash\n"
                "- how the crash happened\n"
                "- where the impact occurred\n"
                "- outcome of the crash\n"
                "Write 4-6 coherent sentences like an incident report. "
                "Do NOT hallucinate unseen details."
            )

            summary = self.generate_caption(frames, summary_prompt)
            return {"text_summary": summary}
        else:
            raise ValueError(f"Task type {task_type} not yet implemented for Qwen-VL")
