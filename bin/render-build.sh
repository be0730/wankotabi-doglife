set -o errexit

bundle install
yarn install --frozen-lockfile
yarn build