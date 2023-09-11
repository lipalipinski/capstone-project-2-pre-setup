resource "aws_cloudwatch_dashboard" "jenkins-dashboard" {
  dashboard_name = "jlipinski-jenkins"

  dashboard_body = jsonencode({
  
    "widgets": [
        {
            "height": 4,
            "width": 6,
            "y": 0,
            "x": 0,
            "type": "metric",
            "properties": {
                "view": "timeSeries",
                "stat": "Average",
                "period": 10,
                "stacked": false,
                "yAxis": {
                    "left": {
                        "min": 0
                    }
                },
                "region": "eu-central-1",
                "metrics": [
                    [ "AWS/EC2", "CPUUtilization", "InstanceId", "${module.jenkins-worker[0].id}", { "label": "${module.jenkins-worker[0].id} (${module.jenkins-worker[0].tags_all["Name"]})" } ],
                    [ "...", "${module.jenkins-worker[1].id}", { "label": "${module.jenkins-worker[1].id} (${module.jenkins-worker[1].tags_all["Name"]})" } ],
                    [ "...", "${module.jenkins-controller.id}", { "label": "${module.jenkins-controller.id} (${module.jenkins-controller.tags_all["Name"]})" } ],
                ],
                "title": "CPU utilization (%)"
            }
        },
        {
            "height": 4,
            "width": 6,
            "y": 4,
            "x": 0,
            "type": "metric",
            "properties": {
                "view": "timeSeries",
                "stat": "Sum",
                "period": 300,
                "stacked": false,
                "yAxis": {
                    "left": {
                        "min": 0
                    }
                },
                "region": "eu-central-1",
                "metrics": [
                    [ "AWS/EC2", "NetworkIn", "InstanceId", "${module.jenkins-worker[0].id}", { "label": "${module.jenkins-worker[0].id} (${module.jenkins-worker[0].tags_all["Name"]})" } ],
                    [ "...", "${module.jenkins-worker[1].id}", { "label": "${module.jenkins-worker[1].id} (${module.jenkins-worker[1].tags_all["Name"]})" } ],
                    [ "...", "${module.jenkins-controller.id}", { "label": "${module.jenkins-controller.id} (${module.jenkins-controller.tags_all["Name"]})" } ],
                ],
                "title": "Network in (bytes)"
            }
        },
        {
            "height": 4,
            "width": 6,
            "y": 4,
            "x": 6,
            "type": "metric",
            "properties": {
                "view": "timeSeries",
                "stat": "Sum",
                "period": 300,
                "stacked": false,
                "yAxis": {
                    "left": {
                        "min": 0
                    }
                },
                "region": "eu-central-1",
                "metrics": [
                    [ "AWS/EC2", "NetworkOut", "InstanceId", "${module.jenkins-worker[0].id}", { "label": "${module.jenkins-worker[0].id} (${module.jenkins-worker[0].tags_all["Name"]})" } ],
                    [ "...", "${module.jenkins-worker[1].id}", { "label": "${module.jenkins-worker[1].id} (${module.jenkins-worker[1].tags_all["Name"]})" } ],
                    [ "...", "${module.jenkins-controller.id}", { "label": "${module.jenkins-controller.id} (${module.jenkins-controller.tags_all["Name"]})" } ],
                ],
                "title": "Network out (bytes)"
            }
        },
    ]
  
})
}