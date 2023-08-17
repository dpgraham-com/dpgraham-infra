# DPGraham-infra
Infrastructure as code for dpgraham.com

# Intro

This repo holds the IaC for provisioning 
resourves on Google cloud (GCP) for my 
personal website. The website consist of 
three major components: a stateless HTTP server, 
a React frontend, and a database.


# prerequisites
1. terraform
2. google cloud billing account
3. gcloud CLI installed
4. registered domain
    - I've been using cloudfare since google 
domains was sold to SquareSpace

# getting started
1. provision


# Background
Learning how to manage an on premise (at home) k8 cluster
taught me a very important lesson, configuration
needs to be declarative and checked into version control.

As part of the migration to the cloud, I aim to
have everything either in code (with HCL) or documented.
no more list of kubectl commands I need to run on X event.

