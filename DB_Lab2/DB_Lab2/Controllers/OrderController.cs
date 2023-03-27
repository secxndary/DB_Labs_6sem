using DB_Lab2.Services;

namespace DB_Lab2.Controllers;
public class OrderController : Controller
{
    private readonly IConfiguration _configuration;
    private OrderService service;

    public OrderController(IConfiguration configuration)
    {
        _configuration = configuration;
        service = new OrderService(configuration);
    }


    // GET
    public IActionResult Index()
    {
        return View();
    }


    // POST
    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult GetOrders(OrderDate orderDate)
    {
        var orders = service.GetOrders(orderDate);
        return View(orders);
    }
}
