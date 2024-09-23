import ballerina/io;

ShoppingServiceClient ep = check new ("http://localhost:9090");


   public function main() returns error? {
    AddProductRequest addProductRequest = {product: {product_id: "p1", product_name: "acer", product_description: "black", product_price: 120000, product_stock: 1, product_sku: "SKU123", product_status: "available"}};
    AddProductResponse addProductResponse = check ep->AddProduct(addProductRequest);
    io:println(addProductResponse);

    ProductUpdateRequest updateProductRequest = {user_id: "U002", product_id: "p1", product: {product_id: "p1", product_name: "Lenovo", product_description: "Grey", product_price: 1, product_stock: 1, product_sku: "SKU123", product_status: "available"}};
    ProductUpdateResponse updateProductResponse = check ep->UpdateProduct(updateProductRequest);
    io:println(updateProductResponse);

    RemoveProductRequest removeProductRequest = {product_sku: "ballerina"};
    RemoveProductResponse removeProductResponse = check ep->RemoveProduct(removeProductRequest);
    io:println(removeProductResponse);

    Empty listAvailableProductsRequest = {};
    ProductListResponse listAvailableProductsResponse = check ep->ListAvailableProducts(listAvailableProductsRequest);
    io:println(listAvailableProductsResponse);

    SearchProductRequest searchProductRequest = {product_sku: "ballerina"};
    SearchProductResponse searchProductResponse = check ep->SearchProduct(searchProductRequest);
    io:println(searchProductResponse);

    AddToCartRequest addToCartRequest = {user_id: "ballerina", product_sku: "ballerina"};
    AddToCartResponse addToCartResponse = check ep->AddToCart(addToCartRequest);
    io:println(addToCartResponse);

    OrderRequest placeOrderRequest = {product_id: "ballerina"};
    OrderResponse placeOrderResponse = check ep->PlaceOrder(placeOrderRequest);
    io:println(placeOrderResponse);

    UserRequest createUsersRequest = {user_id: "ballerina", user_name: "ballerina", user_role: "ballerina"};
    CreateUsersStreamingClient createUsersStreamingClient = check ep->CreateUsers();
    check createUsersStreamingClient->sendUserRequest(createUsersRequest);
    check createUsersStreamingClient->complete();
    UserResponse? createUsersResponse = check createUsersStreamingClient->receiveUserResponse();
    io:println(createUsersResponse);
}


