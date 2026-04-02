FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/rippedpiracy/site.git && \
    cd site && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM --platform=$BUILDPLATFORM node AS build

WORKDIR /site
COPY --from=base /git/site .
RUN npm install --global pnpm && \
    pnpm install --frozen-lockfile && \
    pnpm build

FROM joseluisq/static-web-server

COPY --from=build /site/dist ./public
