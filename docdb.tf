# provisions document db cluster
resource "aws_docdb_cluster" "docdb" {
  cluster_identifier      = "roboshop-${var.ENV}-docdb"
  engine                  = var.DOCDB_ENGINE_VERSION
  master_username         = "admin1"
  master_password         = "RoboShop1"
#   backup_retention_period = 5             # In Prod we would enable this 
#   preferred_backup_window = "07:00-09:00" 
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.allow_docdb.id] 
  db_subnet_group_name    = aws_docdb_subnet_group.docdb.name 
}

# Creates a subnet-groups [ a groups of subnets that we supply to the cluster based resources ]
resource "aws_docdb_subnet_group" "docdb" {
  name                    = "roboshop-${var.ENV}-docdb"
  subnet_ids              = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS

  tags = {
        Name = "roboshop-${var.ENV}-docdb"
  }
}

# Creates Instances and adds them to the cluster
resource "aws_docdb_cluster_instance" "cluster_instances" {
  count                    = var.DOCDB_INSTANCE_COUNT
  identifier               = "roboshop-${var.ENV}-docdb"
  cluster_identifier       = aws_docdb_cluster.docdb.id
  instance_class           = var.DOCDB_INSTANCE_TYPE
}