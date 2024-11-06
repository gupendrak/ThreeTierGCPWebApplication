Purpose and Usage of website_bomber.py
    Purpose: The script bombards the target URL with requests, simulating high traffic. This forces the backend service to consume more CPU, which can trigger the HPA to increase the number of replicas to handle the load.
    
    Usage: It’s typically used in a development or testing environment to verify that your autoscaling policies are configured correctly and to visualize the HPA in action as it scales pods up or down.

Running the Script
    Replace the url in the script with your backend service's URL (e.g., the external IP or LoadBalancer URL).

    Prerequisites:
    Install the aiohttp library if you haven’t already: pip install aiohttp

    Run the script from your command line: python website_bomber.py
    Monitor the HPA in Kubernetes with: kubectl get hpa -w

    Use with Caution: This script generates a large number of requests, so avoid running it against production environments to prevent service degradation.

    Termination: The script may require manual termination (e.g., Ctrl+C) based on the number of requests, as it will keep running until completion.
