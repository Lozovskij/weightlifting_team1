using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WeightliftingTeam1.Data;

namespace WeightliftingTeam1.Pages
{

    public partial class Login
    {
        private Admin user;

        public string LoginMessage { get; set; }

        protected override void OnInitialized()
        {
            user = new Admin();
            LoginMessage = "Admin rights lets you modify db";
            base.OnInitialized();
        }

        public async Task<bool> ValidateUser()
        {

            //if is valid:
            if (PasswordValidation.IsValid(user.Password))
            {
                ((CustomAuthenticationStateProvider)AuthenticationStateProvider).MarkUserAsAuthenticated(PasswordValidation.GetHash(user.Password));

                await sessionStorage.SetItemAsync("hash", PasswordValidation.GetHash(user.Password));

                NavigationManager.NavigateTo("/editing");
            }
            else
            {
                LoginMessage = "Access is denied! Try again";
            }

            return await Task.Run(() => true);
        }
    }


    public class Admin
    {
        public string Password { get; set; }
    }
}
