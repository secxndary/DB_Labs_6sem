namespace DB_Lab2.Models;

public class Author
{
    [Key]
    public int Id { get; set; }

    [Required]
    public string Name { get; set; }

    [Required]
    public string Surname { get; set; }

    [Required]
    public string Country { get; set; }

    [Required]
    public DateTime DateOfBirth { get; set; }
}
