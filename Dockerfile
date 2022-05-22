FROM golang:1.18.2 as buildSvc

WORKDIR $GOPATH/src/github.com/sagolubev/go-server

# Copy everything from the current directory to the PWD(Present Working Directory) inside the container
COPY . .

# Download all the dependencies
RUN go get -d -v ./...

# Install the package
RUN go install -v ./...

RUN CGO_ENABLED=0 go build -a -installsuffix cgo -o server

FROM golang:1.18.2 as buildChk

WORKDIR $GOPATH/src/github.com/sagolubev/go-server

COPY healthcheck ./healthcheck

RUN go mod init && CGO_ENABLED=0 go build -a -installsuffix cgo -o health-check "github.com/sagolubev/go-server/healthcheck"

FROM alpine:3.15.4 as release

COPY --from=buildSvc /go/src/github.com/sagolubev/go-server/server ./server
COPY --from=buildChk /go/src/github.com/sagolubev/go-server/health-check ./healthcheck

HEALTHCHECK --interval=1s --timeout=1s --start-period=2s --retries=3 CMD [ "/healthcheck" ]

# This container exposes port 8080 to the outside world
ENV PORT=8080
EXPOSE $PORT

# Run the executable
CMD ["./server"]
