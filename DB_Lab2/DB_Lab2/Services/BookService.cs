using System.Data;

namespace DB_Lab2.Services;

public class BookService
{
    private readonly IConfiguration _configuration;
    private readonly string connectionString;
    private AuthorService authorService;

    public BookService(IConfiguration configuration)
    {
        _configuration = configuration;
        authorService = new AuthorService(configuration);
        connectionString = _configuration.GetConnectionString("Default");
    }



    public List<Book> GetBooks()
    {
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            var books = new List<Book>();
            var sqlExpression = "SELECT * FROM BOOKS";
            var sqlCommand = new SqlCommand(sqlExpression, conn);
            var sqlDataAdapter = new SqlDataAdapter(sqlCommand);
            var dataTable = new DataTable();

            conn.Open();
            sqlDataAdapter.Fill(dataTable);

            for (var i = 0; i < dataTable.Rows.Count; i++)
            {
                var item = new Book();
                item.Id = Guid.Parse(dataTable.Rows[i]["Id"].ToString());
                item.AuthorId = Guid.Parse(dataTable.Rows[i]["Author_Id"].ToString());
                item.Title = dataTable.Rows[i]["Title"].ToString();
                item.Pages = int.Parse(dataTable.Rows[i]["Pages"].ToString());
                books.Add(item);
            }

            return books;
        }
    }


    public bool AddBook(Book book)
    {
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            book.Id = Guid.NewGuid();
            var sqlExpression = $"INSERT INTO Books(ID, TITLE, PAGES, AUTHOR_ID) VALUES " +
                $"('{book.Id}', N'{book.Title}', {book.Pages}, '{book.AuthorId}');" ;
            var sqlCommand = new SqlCommand(sqlExpression, conn);
            
            conn.Open();
            try
            {
                sqlCommand.ExecuteNonQuery();
                return true;
            }
            catch { return false; }
        }
    }


    public bool UpdateBook(Book book)
    {
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            var author = authorService.GetAuthor(book.AuthorId);
            if (author == null) 
                return false;
            var sqlExpression = $"UPDATE Books SET TITLE = N'{book.Title}', PAGES = {book.Pages}, " +
                $"AUTHOR_ID = '{book.AuthorId}' WHERE ID = '{book.Id}'";
            var sqlCommand = new SqlCommand(sqlExpression, conn);

            conn.Open();
            sqlCommand.ExecuteNonQuery();
        }
        return true;
    }


    public async void DeleteBook(Guid? id)
    {
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            var sqlExpression = $"DELETE FROM Books WHERE ID = '{id}'";
            var sqlCommand = new SqlCommand(sqlExpression, conn);

            conn.Open();
            await sqlCommand.ExecuteNonQueryAsync();
        }
    }


    public Book GetBook(Guid? id) => GetBooks().Find(x => x.Id == id);
}
