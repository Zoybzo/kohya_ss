#!/bin/bash
# 读取参数
GPU_ID=$1
DATASET_ID=$2
# 检查参数是否为空，并设置默认值
if [ -z "$GPU_ID" ]; then
    param1="6"
fi

if [ -z "$DATASET_ID" ]; then
    param2="42"
fi

if [ -z "$COUNTER" ]; then
    export COUNTER=0
fi

export COUNTER=$((COUNTER + 1))
echo "Counter has been incremented to: $COUNTER"
# 格式化为3位数字
FORMATTED_COUNTER=$(printf "%03d" $COUNTER)

# 获取当前日期，格式为月份和日期（两位数），例如 0328
CURRENT_DATE=$(date +%m%d)
# 将当前日期存储到环境变量中
export DATE_VAR=$CURRENT_DATE
# 打印环境变量以验证
echo "Current date environment variable: $DATE_VAR"

$MHOME/Projects/kohya_ss/venv/bin/accelerate launch \
  --dynamo_backend no \
  --dynamo_mode default \
  --gpu_ids $(GPU_ID) \
  --mixed_precision fp16 \
  --num_processes 1 \
  --num_machines 1 \
  --num_cpu_threads_per_process 2 \
  $MHOME/Projects/kohya_ss/sd-scripts/sdxl_train_network.py \
  --train_data_dir "$DATASET_HOME/kafka_official_p$(DATASET_ID)" \
  --output_name "test-$(DATE_VAR)-$(FORMATTED_COUNTER)-sdxl_base_1.0-p$(DATASET_ID)" \
  --config_file config_lora_sdxl-base-1.0_ai-char-1.1.toml
