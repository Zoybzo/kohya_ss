#!/bin/bash
# 读取参数
GPU_ID=$1
DATASET_ID=$2
# 检查参数是否为空，并设置默认值
if [ -z "$GPU_ID" ]; then
    GPU_ID="6"
fi

if [ -z "$DATASET_ID" ]; then
    DATASET_ID="42"
fi

counter_file="$HOME/.counter"
# 确保计数器文件存在
[ ! -f "$counter_file" ] && echo "0" > "$counter_file"
# 读取当前值并加1
current=$(cat "$counter_file")
new_value=$((current + 1))
# 保存新值并导出环境变量
echo "$new_value" > "$counter_file"
export COUNTER="$new_value"
# 可选：打印当前值
echo "COUNTER 已更新为：$COUNTER"

# 获取当前日期，格式为月份和日期（两位数），例如 0328
CURRENT_DATE=$(date +%m%d)
# 将当前日期存储到环境变量中
export DATE_VAR=$CURRENT_DATE
# 打印环境变量以验证
echo "Current date environment variable: $DATE_VAR"

$MHOME/Projects/kohya_ss/venv/bin/accelerate launch \
  --dynamo_backend no \
  --dynamo_mode default \
  --gpu_ids $GPU_ID \
  --mixed_precision fp16 \
  --num_processes 1 \
  --num_machines 1 \
  --main_process_port 0 \
  --num_cpu_threads_per_process 2 \
  $MHOME/Projects/kohya_ss/sd-scripts/sdxl_train_network.py \
  --train_data_dir "$DATASET_HOME/kafka_official_p$DATASET_ID" \
  --output_name "test-${DATE_VAR}-${COUNTER}-sdxl_base_1.0-p$DATASET_ID" \
  --config_file custom_configs/config_lora_sdxl-base-1.0_ai-char-1.1.toml
