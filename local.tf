locals {
    common_tags = {         #if not tags were given, this will fill common tags
        Name = var.project
        environment = var.environment
        terraform = true
    }
    vpc_final_tags = merge (        #by merge function,map1 will be common_tags and map2 will user vpc tags
                local.common_tags,
            {
                Name = "${var.project}-${var.environment}"
            },
            var.vpc_tags
        )
    vpc_final_igw_tags = merge (      #by merge function,map1 will be common_tags and map2 will user igw tags
        local.common_tags,
         {
           Name = "${var.project}-${var.environment}"
         },
        var.igw_tags
    )
}
