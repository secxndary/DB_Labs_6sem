using DB_Lab2.Services;

namespace DB_Lab2.Controllers;

public class AuthorController : Controller
{
    private readonly IConfiguration _configuration;
    private AuthorService service;

    public AuthorController(IConfiguration configuration)
    {
        _configuration = configuration;
        service = new AuthorService(configuration);
    }



    // GET: Index
    public IActionResult Index()
    {
        var authors = service.GetAuthors();
        return View(authors);
    }


    // GET: Create
    public IActionResult Create()
    {
        return View();
    }


    // POST: Create
    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Create(Author author)
    {
        if (ModelState.IsValid)
        {
            service.AddAuthor(author);
            TempData["success"] = "Author successfully created";
            return RedirectToAction("Index");
        }
        return View();
    }


    // GET: Edit
    public IActionResult Edit(Guid? id)
    {
        if (id == null)
            return NotFound();

        var author = service.GetAuthor(id);
        if (author == null)
            return NotFound();

        return View(author);
    }


    // POST: Edit
    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Edit(Author author)
    {
        if (ModelState.IsValid)
        {
            service.UpdateAuthor(author);
            TempData["success"] = "Author successfully updated";
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

        service.DeleteAuthor(id);
        TempData["success"] = "Author successfully deleted";
        return RedirectToAction("Index");
    }
}
