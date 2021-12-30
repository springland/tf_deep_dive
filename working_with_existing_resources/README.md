step 1

Build a VPC with 10.0.0.0/16 CIDR block
4 subnets in two az in us-west2 region

two public and two private
public : 10.0.0.0/24 , 10.0.1.0/24
private: 10.0.10.0/24 , 10.0.11.0/24

Step 2
Add subnets in a thrid az manually  us-west-2c
public : 10.0.2.0/24
private : 10.0.12.0/24

Because the us-west-2c subnets were added manually terraform is not aware of them

aws ec2 describe-availability-zones --region us-west-2

        {
            "State": "available",
            "OptInStatus": "opt-in-not-required",
            "Messages": [],
            "RegionName": "us-west-2",
            "ZoneName": "us-west-2c",
            "ZoneId": "usw2-az3",
            "GroupName": "us-west-2",
            "NetworkBorderGroup": "us-west-2",
            "ZoneType": "availability-zone"
        }



get vpc id

vpcid=`aws ec2 describe-vpcs --filters Name=tag:Name,Values=tf-vpc-working-with-existing-resources | jq '.Vpcs[0].VpcId' | tr -d '"'`

get internet gateway id
igwid=`aws ec2 describe-internet-gateways --filters Name=tag:Name,Values=tf-vpc-working-with-existing-resources | jq '.InternetGateways[0].InternetGatewayId' | tr -d '"'`



***Create Public Subnet***

public_subnet_id=`aws ec2 create-subnet --availability-zone us-west-2c  --cidr-block 10.0.2.0/24  --vpc-id $vpcid  --query Subnet.SubnetId  --output text`
subnet-0dd0037139118d4e0    
aws ec2 delete-subnet --subnet-id $public_subnet_id


**Find route table for public subnets**
rtb_id=`aws ec2 describe-route-tables --filter Name=tag:Name,Values=tf-vpc-working-with-existing-resources-public |jq '.RouteTables[0].RouteTableId' | tr -d '"'`

rtb-06203ed6081aeb6a1
**Associate Route to subnet**
aws ec2 associate-route-table  --subnet-id $public_subnet_id --route-table-id $rtb_id


***Create private subnet***

private_subnet_id=`aws ec2 create-subnet --availability-zone us-west-2c --cidr-block 10.0.12.0/24     --vpc-id $vpcid  --query Subnet.SubnetId  --output text`

aws ec2 delete-subnet --subnet-id $private_subnet_id
subnet-001e5bd303eb2b74d

**Create Route table**
priv_rtb_id=`aws ec2 create-route-table --vpc-id $vpcid --query RouteTable.RouteTableId --output text`
rtb-0a548aab71fd02f21

**Associate Route to subnet**
aws ec2 associate-route-table  --subnet-id $private_subnet_id --route-table-id $priv_rtb_id


Need to import them into terraform

Update terraform.tfstate file to include the new subnet information

Then run tf plan to get the addr of new resources

module.vpc.aws_route_table.private[2] will be created
module.vpc.aws_route_table_association.private[2] will be created
module.vpc.aws_route_table_association.public[2] will be created  ( It does not require public route table , it has been created before )
  + resource "aws_route_table_association" "public" {
      + id             = (known after apply)
      + route_table_id = "rtb-06203ed6081aeb6a1"
      + subnet_id      = (known after apply)
    }
module.vpc.aws_subnet.private[2] will be created
 module.vpc.aws_subnet.public[2] will be created



tf import module.vpc.aws_subnet.public[2]  subnet-0dd0037139118d4e0

**I am wondering why it does not use the assocation id but the subnetid/routetableid**
tf import module.vpc.aws_route_table_association.public[2] subnet-0dd0037139118d4e0/rtb-06203ed6081aeb6a1

tf import module.vpc.aws_subnet.private[2]  subnet-001e5bd303eb2b74d
tf import module.vpc.aws_route_table.private[2] rtb-0a548aab71fd02f21
tf import module.vpc.aws_route_table_association.private[2] subnet-001e5bd303eb2b74d/rtb-0a548aab71fd02f21


