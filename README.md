## Deploying a  Web Application on EC2 with CI/CD and Security Controls

## Project Overview 📝

This project implements a cloud-based architecture for hosting a web application using AWS services. It includes content delivery, security measures, monitoring, and CI/CD for application deployment. Below are the detailed steps we followed to implement and configure this architecture.

---

## Steps to Build the Project 🛠️

### 1. Setting Up the EC2 Instance 🖥️

- **Purpose:** Host the web application.
- **Steps:**
  1. Launch an EC2 instance using the Amazon Linux 2 AMI.
  2. Configure security groups to allow HTTP (port 80) and SSH (port 22).
  3. Connect to the instance using SSH:
     ```bash
     ssh -i your-key.pem ec2-user@<EC2_PUBLIC_IP>
     ```
  4. Install necessary software (e.g., Apache):
     ```bash
     sudo yum update -y
     sudo yum install httpd -y
     sudo systemctl start httpd
     sudo systemctl enable httpd
     ```

### 2. Creating an S3 Bucket for Static Content 🪣

- **Purpose:** Store static assets like images, CSS, and JavaScript files.
- **Steps:**
  1. Navigate to the S3 console and create a bucket.
  2. Enable public read access for the bucket (with caution!).
  3. Upload static content to the bucket.

### 3. Configuring CloudFront 🌐

- **Purpose:** Distribute content globally with low latency.
- **Steps:**
  1. Create a CloudFront distribution.
  2. Set the S3 bucket as the origin for static content.
  3. Configure caching and security settings (e.g., HTTPS).

### 4. Setting Up the Application Load Balancer (ALB) ⚖️

- **Purpose:** Distribute traffic to backend instances.
- **Steps:**
  1. Navigate to the EC2 console and create an ALB.
  2. Configure the ALB to forward traffic to the EC2 instance on port 80.
  3. Create a target group and register the EC2 instance.
  4. Add security settings to ensure only necessary traffic passes through.

### 5. Implementing Security with WAF 🔒

- **Purpose:** Filter malicious traffic.
- **Steps:**
  1. Configure AWS WAF with rules to block suspicious IPs and request patterns.
  2. Attach the WAF to the CloudFront distribution for global protection.

### 6. Setting Up CloudWatch 📊

- **Purpose:** Monitor logs and metrics for the application.
- **Steps:**
  1. Enable logging for the ALB and EC2 instance.
  2. Configure CloudWatch alarms for resource usage thresholds (CPU, memory, etc.).

### 7. Creating and Configuring the RDS Instance 💾

- **Purpose:** Host the application’s database.
- **Steps:**
  1. Launch an RDS instance with the required database engine (e.g., MySQL).
  2. Set up a security group to allow database access only from the EC2 instance.
  3. Initialize the database schema.

---

## Deployment Process 🚀

### 1. Setting Up CodeCommit for Version Control 🧑‍💻

- **Steps:**
  1. Create a repository in AWS CodeCommit.
  2. Clone the repository locally and add your application code:
     ```bash
     git clone https://git-codecommit.<REGION>.amazonaws.com/v1/repos/<REPO_NAME>
     cd <REPO_NAME>
     git add .
     git commit -m "Initial commit"
     git push origin main
     ```

### 2. Configuring CodePipeline for CI/CD 📦

- **Steps:**
  1. Create a pipeline in CodePipeline.
  2. Connect the pipeline to the CodeCommit repository.
  3. Add CodeBuild as the build provider and configure the buildspec.yml file.
  4. Use CodeDeploy to deploy the application to the EC2 instance.

#### 2.1 **Scripts for Automation**

Upload the following scripts to the EC2 instance:

#### **install_dependencies.sh**
```bash
#!/bin/bash
# Update the system
echo "Updating system packages..."
sudo yum update -y

# Install dependencies
echo "Installing dependencies..."
sudo yum install -y httpd git
```

#### **start_server.sh**
```bash
#!/bin/bash
# Start the Apache web server
echo "Starting Apache web server..."
sudo systemctl start httpd

# Enable Apache on boot
echo "Enabling Apache to start on boot..."
sudo systemctl enable httpd

# Log message
echo "Server started successfully!" >> app.log
```

#### 🚀 **How to Use These Scripts**

##### 🛠️ **Step 1: Upload the Files**
- Upload `install_dependencies.sh` and `start_server.sh` to your EC2 instance.
- Place the scripts in a directory like `/home/ec2-user/scripts/` for better organization.

##### ✍️ **Step 2: Make the Scripts Executable**
Ensure the scripts have execution permissions:
```bash
chmod +x install_dependencies.sh  
chmod +x start_server.sh
```

##### ▶️ **Step 3: Run the Scripts**
- **To install dependencies:**
  ```bash
  sudo ./install_dependencies.sh
  ```
- **To start the application:**
  ```bash
  sudo ./start_server.sh
  ```

---



### 3. Creating the Buildspec File ⚙️

- **Purpose:** Define build instructions for CodeBuild.
- ****`buildspec.yml`****:
  ```yaml
  version: 0.2
  phases:
    install:
      commands:
        - echo Installing dependencies
        - yum install -y httpd
    build:
      commands:
        - echo Building the application
    post_build:
      commands:
        - echo Deployment complete
  artifacts:
    files:
      - '**/*'
  ```

### 4. Deploying the Application via CodeDeploy 🚀

- **Steps:**
  1. Create a CodeDeploy application and deployment group.
  2. Specify the EC2 instance as the target environment.
  3. Configure the `appspec.yml` file for deployment:
     ```yaml
     version: 0.0
     os: linux
     files:
       - source: /
         destination: /var/www/html
     hooks:
       BeforeInstall:
         - location: scripts/install_dependencies.sh
           timeout: 300
       ApplicationStart:
         - location: scripts/start_server.sh
           timeout: 300
     ```
  4. Trigger a deployment from CodePipeline or manually from the console.

---

## Final Testing and Verification ✅

### 1. Test Load Balancer and Application Access 🌐

- Access the application via the ALB’s DNS name.
- Verify that the static content is served from CloudFront and S3.

### 2. Monitor Logs and Metrics 📊

- Use CloudWatch to check for application logs and resource usage.

### 3. Validate CI/CD Pipeline 🚧

- Push a code change to the CodeCommit repository and ensure the pipeline deploys it successfully.

---



