using System.ComponentModel.DataAnnotations;

namespace API.Models
{
    public class User
    {
        [Key] 
        public int Id { get; set; }
        [Required]
        [MaxLength(255)]
        public string Username { get; set; }
        [Required]
        public string Password {  get; set; }
        [Required]
        public string Email { get; set; }
        [Required]
        public string FullName { get; set; }
    }
}
