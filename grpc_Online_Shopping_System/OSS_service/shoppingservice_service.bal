import ballerina/grpc;
import ballerina/io;
import ballerina/time;

map<Product> productStore = {};


listener grpc:Listener ep = new (9090);

@grpc:Descriptor {value: GRPC_DESC}
service "ShoppingService" on ep {

    remote function AddProduct(AddProductRequest request) returns AddProductResponse|error {
        Product product = request.product;
        productStore[product.product_id] = product;
        return {product_id:product.product_id ,message: "Product added successfully"};
   
}
 remote function UpdateProduct(ProductUpdateRequest value) returns ProductUpdateResponse|error {
        string requestedUser = value.user_id;


        //check if the user exists
        foreach var user in userStore {
            if user.user_role != "admin" && user.user_id== requestedUser{
            return error("Only admin users are allowed to update products.");
            
            }
        }


    // Iterate through the productStore to find the product by product_id

    Product? matchedProduct = ();

    foreach var product in productStore {
        if product.product_id == value.product.product_id {
            matchedProduct = product;
            break; // Exit the loop once the product is found
        }
    }

    if matchedProduct is Product {
        // Update the product fields with the provided values
        matchedProduct.product_name = value.product.product_name;
        matchedProduct.product_description = value.product.product_description;
        matchedProduct.product_price = value.product.product_price;
        matchedProduct.product_stock = value.product.product_stock;
        matchedProduct.product_sku = value.product.product_sku;
        matchedProduct.product_status = value.product.product_status;

        // Update the product in the productStore
        productStore[matchedProduct.product_id] = matchedProduct;

        // Return a success message
        ProductUpdateResponse response = {
            message: "Product updated successfully."
        };
        return response;
    } else {
        // If the product does not exist, return an error
        return error("Product not found for the provided product_id.");
    }
        
    }



   

    remote function RemoveProduct(RemoveProductRequest value) returns RemoveProductResponse|error {
    }

    remote function ListAvailableProducts(Empty value) returns ProductListResponse|error {
    }

    remote function SearchProduct(SearchProductRequest value) returns SearchProductResponse|error {
    }

    remote function AddToCart(AddToCartRequest value) returns AddToCartResponse|error {
    }

    remote function PlaceOrder(OrderRequest value) returns OrderResponse|error {
    }

    remote function CreateUsers(stream<UserRequest, grpc:Error?> clientStream) returns UserResponse|error {
    }
}

