using DB_Lab2.Services;

namespace DB_Lab2.Controllers;

public class BookController : Controller
{
    private readonly IConfiguration _configuration;
    private BookService service;

    public BookController(IConfiguration configuration) 
    { 
        _configuration = configuration;
        service = new BookService(configuration);
    }



    // GET: Index
    public IActionResult Index()
    {
        var books = service.GetBooks();      
        return View(books);
    }

    
    // GET: Create
    public IActionResult Create()
    {
        return View();
    }


    // POST: Create
    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Create(Book book)
    {
        if (ModelState.IsValid)
        {
            service.AddBook(book);
            TempData["success"] = "Book successfully created";
            return RedirectToAction("Index");
        }
        return View();
    }


    // GET: Edit
    public IActionResult Edit(Guid? id)
    {
        if (id == null)
            return NotFound();

        var book = service.GetBook(id);
        if (book == null)
            return NotFound();
        
        return View(book);
    }


    // POST: Edit
    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Edit(Book book)
    {
        if (ModelState.IsValid)
        {
            service.UpdateBook(book);
            TempData["success"] = "Book successfully updated";
            return RedirectToAction("Index");
        }
        return View();
    }


    // POST: Delete
    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Delete(Guid? id)
    {
        if (id == null)
            return NotFound();

        service.DeleteBook(id);
        TempData["success"] = "Book successfully deleted";
        return RedirectToAction("Index");
    }
}
