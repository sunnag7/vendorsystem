
class FormModel {

  late final String category;
  late final String productname;
  late final String brand;
  late final String deliveryestimate;
  late final String pricerange;
  late final String serviceandsalesterms;

  FormModel(this.category,this.productname, this.brand, this.deliveryestimate,this.pricerange,this.serviceandsalesterms);

  FormModel.fromJson(Map<String, dynamic> json)
  {
    category = json['category'];
    productname = json['productname'];
    brand = json['brand'];
    brand = json['deliveryestimate'];
    brand = json['pricerange'];
    brand = json['serviceandsalesterms'];
  }

  Map<String, dynamic> toJson() => {
    'category': category,
    'productname': productname,
    'brand': brand,
    'deliveryestimate': deliveryestimate,
    'pricerange': pricerange,
    'serviceandsalesterms': serviceandsalesterms,

  };
}