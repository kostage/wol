docker build -t wol-app .

docker run --rm -p 8080:80 --name wol-app wol-app

pyenv shell aider
aider --model openrouter/deepseek/deepseek-chat --api-key openrouter="$DS_V3_FREE"
