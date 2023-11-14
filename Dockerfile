# Use a Python image for building
FROM python:3.9-slim-buster AS builder

# Set the working directory
WORKDIR /build

# define Env variable 
ENV SECRET_KEY=passcode999
ENV JWT_SECRET_KEY=access
ENV ADMIN_EMAIL_CREDENTIAL=efefiomarchibong@gmail.com
ENV SECURITY_PASSWORD_SALT=fullaccess
ENV FLASK_ENV=my_APP

# Copy requirements.txt into the image
COPY ./requirements.txt /build/requirements.txt

RUN apt-get update && apt-get install -y build-essential

# Install project dependencies
RUN pip install -r /build/requirements.txt


# Copy the source code
COPY . .

# Build the Flask app
RUN ["python", "app.py"]

# Use a smaller base image for production
FROM python:3.9-slim AS production

# Copy only the built app from the builder stage
COPY --from=builder /build /build


# Expose the Flask API port
EXPOSE 5000

# Start the Flask app
CMD ["python", "app.py"]
