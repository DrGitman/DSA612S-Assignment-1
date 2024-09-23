import ballerina/grpc;
import ballerina/io;
import ballerina/time;

map<Product> productStore = {};


listener grpc:Listener ep = new (9090);

@grpc:Descriptor {value: GRPC_DESC}
service "ShoppingService" on ep {

    remote function AddProduct(AddProductRequest value) returns AddProductResponse|error {
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

