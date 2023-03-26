namespace DB_Lab2.Models;

public class Author
{
    [Key]
    public Guid Id { get; set; }

    [Required]
    public string Name { get; set; }

    [Required]
    public string Surname { get; set; }

    public string Country { get; set; }

    [Required]
    public DateTime DateOfBirth { get; set; }
}
