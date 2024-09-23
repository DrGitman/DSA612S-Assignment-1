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

// Request to list all available products
Empty listAvailableProductsRequest = {};
    ProductListResponse listAvailableProductsResponse = check ep->ListAvailableProducts(listAvailableProductsRequest);
    io:println(listAvailableProductsResponse); 
// Call the SearchProduct method
    SearchProductRequest searchProductRequest = {product_sku: "T-002"}; // Define the SKU for the search
    SearchProductResponse searchProductResponse = check ep->SearchProduct(searchProductRequest);
    
    // Print the product details if found
    io:println("Product Details:");
    io:println("Product ID: ", searchProductResponse.product.product_id);
    io:println("Product Name: ", searchProductResponse.product.product_name);
    io:println("Product Description: ", searchProductResponse.product.product_description);
    io:println("Product Price: ", searchProductResponse.product.product_price);
    io:println("Product Stock: ", searchProductResponse.product.product_stock);
    io:println("Product SKU: ", searchProductResponse.product.product_sku);
    io:println("Product Status: ", searchProductResponse.product.product_status);

    AddToCartRequest addToCartRequest = {user_id: "ballerina", product_sku: "ballerina"};
    AddToCartResponse addToCartResponse = check ep->AddToCart(addToCartRequest);
    io:println(addToCartResponse);

    OrderRequest placeOrderRequest = {product_id: "p1"};
    OrderResponse placeOrderResponse = check ep->PlaceOrder(placeOrderRequest);
    io:println(placeOrderResponse);


    UserRequest createUsersRequest1 = {user_id: "U001", user_name: "Alice", user_role: "customer"};
    UserRequest createUsersRequest2 = {user_id: "U002", user_name: "Bob", user_role: "admin"};

    CreateUsersStreamingClient createUsersStreamingClient = check ep->CreateUsers();

    check createUsersStreamingClient->sendUserRequest(createUsersRequest1);
    check createUsersStreamingClient->sendUserRequest(createUsersRequest2);

    check createUsersStreamingClient->complete();

    UserResponse? createUsersResponse = check createUsersStreamingClient->receiveUserResponse();
    io:println("Create Users Response: ", createUsersResponse);
}


