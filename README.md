docker build -t wol-app .

docker run --rm -p 8080:80 --name wol-app wol-app

pyenv shell aider
aider --model openrouter/deepseek/deepseek-chat --api-key openrouter="$DS_V3_FREE"

aider \
  --architect  \
  --model  \
  --model-metadata-file .aider.model.metadata.json \
  --editor-model deepseek/deepseek-chat \
  --load .aiderno

echo "file:Dockerfile" >> allcode && cat Dockerfile >> allcode
echo "file:config.json" >> allcode && cat config.json >> allcode
echo "file:index.html" >> allcode && cat index.html >> allcode
echo "file:mock_config.json" >> allcode && cat mock_config.json >> allcode
echo "file:start.sh" >> allcode && cat start.sh >> allcode
echo "file:state.json" >> allcode && cat state.json >> allcode
echo "file:status.sh" >> allcode && cat status.sh >> allcode
echo "file:wol.sh" >> allcode && cat wol.sh >> allcode
echo "file:mock/etherwake" >> allcode && cat mock/etherwake >> allcode
echo "file:mock/ping" >> allcode && cat mock/ping >> allcode

echo "file:test/run_tests.sh" >> allcode && cat test/run_tests.sh >> allcode
echo "file:test/integration/app_test.bats" >> allcode && cat test/integration/app_test.bats >> allcode
echo "file:test/unit/status_test.bats" >> allcode && cat test/unit/status_test.bats >> allcode
echo "file:test/unit/test_helper.bash" >> allcode && cat test/unit/test_helper.bash >> allcode
echo "file:test/unit/wol_test.bats" >> allcode && cat test/unit/wol_test.bats >> allcode

test/run_tests.sh
test/integration/app_test.bats
test/unit/status_test.bats
test/unit/test_helper.bash
test/unit/wol_test.bats