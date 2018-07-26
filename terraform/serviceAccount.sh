gcloud iam service-accounts create terraform --display-name "Terraform admin account"
gcloud iam service-accounts list
gcloud iam service-accounts keys create ${TF_CREDS} --iam-account terraform@${TF_ADMIN}.iam.gserviceaccount.com
gcloud services enable cloudresourcemanager.googleapis.com cloudbilling.googleapis.com iam.googleapis.com compute.googleapis.com
gcloud projects add-iam-policy-binding ${TF_PROJECT} --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com --role roles/viewer
gcloud projects add-iam-policy-binding ${TF_PROJECT} --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com --role roles/storage.admin
gcloud projects add-iam-policy-binding ${TF_PROJECT} --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com --role roles/compute.instanceAdmin
gcloud projects add-iam-policy-binding ${TF_PROJECT} --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com --role roles/compute.networkAdmin

# create role w/ compute.firewall.* persmissions
# so do not have to set securityAdmin
gcloud projects add-iam-policy-binding ${TF_PROJECT} --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com --role projects/${TF_ADMIN}/roles/firewallAdmin
