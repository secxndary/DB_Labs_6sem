using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace DB_Lab2.Models;

public class Book
{
    [Key]
    public Guid Id { get; set; }

    [DisplayName("Author Id")]
    [Required]
    public Guid AuthorId { get; set; }
    
    [Required]
    public string Title { get; set; }
    
    [Required]
    [Range(1, 2000, ErrorMessage = "Pages quantity must be between 1 and 2000.")]
    public int Pages { get; set; }  

}
