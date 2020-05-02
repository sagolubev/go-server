FROM golang:1.14.2

WORKDIR $GOPATH/src/github.com/sagolubev/go-server

# Copy everything from the current directory to the PWD(Present Working Directory) inside the container
COPY . .

# Download all the dependencies
RUN go get -d -v ./...

# Install the package
RUN go install -v ./...

# This container exposes port 8080 to the outside world
EXPOSE 9090

# Run the executable
CMD ["go-server"]