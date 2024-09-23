import ballerina/grpc;
import ballerina/io;
import ballerina/time;

map<Product> productStore = {};
map<Cart> cartStore = {};
map<UserRequest> userStore= {};
map<Product[]> userCarts = {};

 Product[] availableProducts = [];
 Product[] userCart = [];

// Define Cart type which holds the cart items by SKU
type Cart record {
    map<CartItem> items;
};

// Cart item definition
type CartItem record {
    string product_id;
    string product_name;
    float product_price;
    int quantity;
};


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

    // RemoveProduct implementation using iteration to find the product by SKU
    remote function RemoveProduct(RemoveProductRequest value) returns RemoveProductResponse {
        string productSku = value.product_sku;

        // Iterate over the productStore map to find the product by SKU
        foreach var productKey in productStore.keys() {
            Product? productOpt = productStore[productKey];

            // Check if the product exists (is not nil)
            if productOpt is Product {
                // If the product's SKU matches the requested SKU
                if productOpt.product_sku == productSku {
                    // If the product is found, remove it from the productStore
                    _ = productStore.remove(productKey);
                    return { message: "Product removed successfully" };
                }
            }
        }

        // If the product is not found, return a message indicating the same
        return { message: "Product not found" };
    }

    // Customer operations
remote function ListAvailableProducts(Empty value) returns ProductListResponse|error {
    // Create a list to hold available products
    Product[] availableProducts = [];

    // Iterate over the productStore map to find available products
    foreach var product in productStore {
        if product.product_status == "available" && product.product_stock > 0 {
            availableProducts.push(product);
        }
    }
    // Return the available products
    return { products: availableProducts };
    }
    


        remote function SearchProduct(SearchProductRequest value) returns SearchProductResponse|error {
    // Get the SKU from the request
    string requestedSku = value.product_sku;

    // Iterate over the productStore map to find a product by SKU
    foreach var product in productStore {
        if product.product_sku == requestedSku {
            // If the product is found, return the product's details
            return {product: product};
        }
    }
    // Return an error if the product is not found
    return error("Product not available for the provided SKU.");
    }

remote function AddToCart(AddToCartRequest value) returns AddToCartResponse|error {
    string requestedSku = value.product_sku;
    string userId = value.user_id;
    UserRequest? matchedUser = ();

    // Iterate over the userStore map to find the user by user_id
    foreach var user in userStore {
        if user.user_id == userId {
            matchedUser = user;
            io:println("User found: ", userId);
            break;
        }
    }

    // If the user is not found, return an error
    if matchedUser is () {
        return error("User not found");
    }

    // Check if the product exists in the productStore by SKU
        foreach var product in productStore {
        if product.product_sku == requestedSku {
             io:println("product found", requestedSku);

            // If the product is found, return the product's details
             
             userCart.push(product);
                foreach var cartProduct in userCart {
                io:println("Product ID: ", cartProduct.product_id);
                io:println("Product Name: ", cartProduct.product_name);
                io:println("Product SKU: ", cartProduct.product_sku);
                io:println("Product Price: ", cartProduct.product_price);
                io:println("-----------------------------------");
            }
             return { message: "Product added to cart successfully"};

        }
    }
    return error("product not found");
     
}
    

    remote function PlaceOrder(OrderRequest value) returns OrderResponse|error {
        string product_id = value.product_id;

        // Check if the user has a cart


        if userCart.length() == 0 {
            return {message: "Cart is empty. Cannot place an order."};
        }

        // Create a unique order ID (for simplicity, using the user ID and timestamp)
        string orderId = "ORDER_" + product_id + "_" + time:utcNow().toString();

        // Iterate over the user's cart and reduce stock
        Product[] orderedProducts = [];
        foreach Product product in userCart {
            // Check product availability
            Product? storedProduct = productStore[product.product_id];
            if storedProduct is Product && storedProduct.product_stock > 0 {
                storedProduct.product_stock -= 1; // Reduce the stock by 1
                productStore[product.product_id] = storedProduct; // Update the productStore
                orderedProducts.push(product); // Add the product to the order
            }
        }

        // Clear the user's cart after placing the order
        userCarts[product_id] = [];

        // Return the order response with ordered products
        return {order_id: orderId, products: orderedProducts, message: "Order placed successfully"};
    }
     
    


        // User operations: Create multiple users via streaming
    remote function CreateUsers(stream<UserRequest, grpc:Error?> clientStream) returns UserResponse|error {
        int usersCreated = 0;
        UserRequest[] createdUsers = []; // Array to hold created users

        // Handle errors and processing of the stream
        grpc:Error? streamError = clientStream.forEach(function(UserRequest userReq) {
            // Add user to the map (userStore)
            userStore[userReq.user_id] = userReq; // Store user in the map
            createdUsers.push(userReq); // Store the created user in the array
            usersCreated += 1;
        });

        // Check if there was an error during streaming
        if streamError is grpc:Error {
            return streamError; // Return the error if one occurred
        }

        // Return a response indicating success with created users
        UserResponse response = {
            message: "Users successfully created."// Include the created users in the response
        };

        return response; // Return the UserResponse instance
    }
    
    }
// Preload a product into the productStore