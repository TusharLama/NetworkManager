# NetworkManager

A description of this package.

A network manager package

1 - HTTPMethod Enum to represent the http methods. 
Each request that we call would need this enum value to determine which method that the network layer should use when create a http request.
2 - DataRequest protocol - Whenever we want to create a new request, it need to conform to this   protocol. It also has an associated type called Response, and it value type depends to the concrete type that we define in the client side.
3 - protocol NetworkService will have a function and will use all DataRequest values
4 - NetworkManager Class will be used to call the webservice 
5 - We can view Example Request class to see how we can create request
6 - We can also view example view model to call API.
