import ballerina/grpc;

listener grpc:Listener ep = new (9090);

@grpc:Descriptor {value: GRPC_DESC}
service "ShoppingService" on ep {

    remote function AddProduct(AddProductRequest value) returns AddProductResponse|error {
    }

    remote function UpdateProduct(ProductUpdateRequest value) returns ProductUpdateResponse|error {
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

