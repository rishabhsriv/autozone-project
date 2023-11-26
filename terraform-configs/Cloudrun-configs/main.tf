provider "google" {
  credentials = file("service-account-key path")
  project = "terraform-cloudrun-example"
  region      = "asia-south1" 
}
# Deploy image to Cloud Run
resource "google_cloud_run_service" "myweb-app" {
  name     = "mycloudrun-app"
  location = "asia-south1"
  template {
    spec {
      containers {
        image = "gcr.io/rishabhsriv13/cloud-run-ex"
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
}
# Create public access
data "google_iam_policy" "no-auth-policy" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}
# Enable public access on Cloud Run service
resource "google_cloud_run_service_iam_policy" "no-auth-policy" {
  location    = google_cloud_run_service.myweb-app.location
  project     = google_cloud_run_service.myweb-app.project
  service     = google_cloud_run_service.myweb-app.name
  policy_data = data.google_iam_policy.no-auth-policy.policy_data
}
# Return service URL
output "url" {
  value = "${google_cloud_run_service.myweb-app.status[0].url}"
}


