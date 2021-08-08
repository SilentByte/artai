#!/usr/bin/env bash

set -e

clone_ifne() {
    if [ ! -d "$1" ]; then
        git clone "$2"
    fi
}

clone_ifne VQGAN-CLIP https://github.com/nerdyrodent/VQGAN-CLIP.git

cd VQGAN-CLIP
git checkout 628357b6a7c04863b04c9e500011da0f94afdbed

virtualenv --python python3 venv

source ./venv/bin/activate

pip install torch==1.9.0+cu111 \
            torchvision==0.10.0+cu111 \
            torchaudio==0.9.0 \
            -f https://download.pytorch.org/whl/torch_stable.html \
            ftfy \
            regex \
            tqdm \
            omegaconf \
            pytorch-lightning \
            IPython \
            kornia \
            imageio \
            imageio-ffmpeg \
            einops \
            torch_optimizer

(
    clone_ifne CLIP https://github.com/openai/CLIP
    cd CLIP
    git checkout 8cad3a736a833bc4c9b4dd34ef12b52ec0e68856
)

(
    clone_ifne taming-transformers https://github.com/CompVis/taming-transformers.git
    cd taming-transformers
    git checkout 9d17ea64b820f7633ea6b8823e1f78729447cb57
)

mkdir -p checkpoints
bash ./download_models.sh
