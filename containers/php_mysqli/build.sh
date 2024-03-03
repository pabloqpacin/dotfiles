img='pabloqpacin/php_mysqli'


latest(){
    tag='1.0.20240303'

# docker buildx ls
    # docker buildx create --use
    docker buildx build --platform linux/amd64,linux/arm64 -t "$img":"$tag" --load .
    # docker load
# emm... wtf

    # docker login
    # docker push "$img":"$tag"
}


v1(){
    tag='v1'

    docker build -t "$img":"$tag" .

    docker login
    docker push "$img":"$tag"
}

latest
