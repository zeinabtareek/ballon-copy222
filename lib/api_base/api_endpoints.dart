enum Endpoint {
  getHomeAds,
  getMainCategories,
  getProducts,
  subCategories,
  getAllDrinks,
  getBranchesAddresses,
  getRestaurantFees,
  getRestaurantMoreInfo,
  getDiscount,
  getCouponUsed,
  getBarcodes,
  getBarcodesUsed,
}

Map<Endpoint, String> endpoint = {
  Endpoint.getHomeAds: "ads",
  Endpoint.getMainCategories: "categories",
  Endpoint.subCategories: "subcategories",
  Endpoint.getProducts: "categories/products/",
  Endpoint.getAllDrinks: "drinks",
  Endpoint.getBranchesAddresses: "branches",
  Endpoint.getRestaurantFees: "accounts",
  Endpoint.getRestaurantMoreInfo: "socials",
  Endpoint.getDiscount: "coupons/discount",
  Endpoint.getCouponUsed: 'coupons/used',
  Endpoint.getBarcodes: 'barcodes/',
  Endpoint.getBarcodesUsed: 'usedbarcode/create',
};

const String moreInfo = "categories";
