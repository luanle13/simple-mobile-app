using API.DTOs;
using API.Models;
using AutoMapper;

namespace API.Profiles
{
    public class UserProfile : Profile
    {
        public UserProfile() { 
            CreateMap<User, UserDto>();
            CreateMap<RegisterDto, User>();
            CreateMap<EditProfileDto, User>();
        }
    }
}
