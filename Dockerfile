FROM alpine/git AS base

ARG TAG=latest
RUN git clone --recurse-submodules https://github.com/rippedpiracy/site.git && \
    cd site && \
    ([[ "$TAG" = "latest" ]] || (git checkout ${TAG} && git submodule update --recursive))
    # rm -rf .git

FROM --platform=$BUILDPLATFORM python AS build

WORKDIR /site
COPY --from=base /git/site .
RUN pip install -r requirements.txt && \
    mkdocs build

FROM joseluisq/static-web-server

COPY --from=build /site/site ./public
