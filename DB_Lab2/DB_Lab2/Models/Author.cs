namespace DB_Lab2.Models;

public class Author
{
    [Key]
    public Guid Id { get; set; }

    [Required(ErrorMessage = "Author Name is required.")]
    public string Name { get; set; }

    [Required(ErrorMessage = "Author Surname is required.")]
    public string Surname { get; set; }

    public string Country { get; set; }

    [Required(ErrorMessage = "Author's Date of Birth is required.")]
    public DateTime DateOfBirth { get; set; }
}
