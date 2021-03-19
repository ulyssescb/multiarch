FROM --platform=$BUILDPLATFORM golang:1.13.4 as build

WORKDIR /src

ENV CGO_ENABLED=0

COPY multiarch/go.mod .
COPY multiarch/go.sum .

RUN go mod download

COPY multiarch .

ARG TARGETOS
ARG TARGETARCH

RUN  GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -tags netgo -o /out/multiarch .

FROM alpine:latest

RUN apk --no-cache add ca-certificates

COPY --from=build /out/multiarch /usr/local/bin

ENTRYPOINT ["/usr/local/bin/multiarch"]
CMD ["hello"]

