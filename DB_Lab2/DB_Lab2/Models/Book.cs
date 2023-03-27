namespace DB_Lab2.Models;

public class Book
{
    [Key]
    public Guid Id { get; set; }

    [DisplayName("Author Id")]
    [Required(ErrorMessage = "Author Id is required.")]
    public Guid AuthorId { get; set; }
    
    [Required(ErrorMessage = "Title is required.")]
    public string Title { get; set; }
    
    [Required(ErrorMessage = "Pages are required.")]
    [Range(1, 2000, ErrorMessage = "Pages quantity must be between 1 and 2000.")]
    public int Pages { get; set; }  
}
