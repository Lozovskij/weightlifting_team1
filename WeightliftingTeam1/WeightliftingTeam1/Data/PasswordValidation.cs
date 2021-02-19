using System;
using System.Security.Cryptography;
using System.Text;

namespace WeightliftingTeam1.Data
{
    public static class PasswordValidation
    {
        //SHA512
        private const string 
            _hash = "b109f3bbbc244eb82441917ed06d618b9008dd09b3befd1b5e07394c706a8bb980b1d7785e5976ec049b46df5f1326af5a2ea6d103fd07c95385ffab0cacbc86";

        public static string GetHash(string source)
        {
            string hash = string.Empty;
            using (SHA512 sha512Hash = SHA512.Create())
            {
                //From String to byte array
                byte[] sourceBytes = Encoding.UTF8.GetBytes(source);
                byte[] hashBytes = sha512Hash.ComputeHash(sourceBytes);
                hash = BitConverter.ToString(hashBytes).Replace("-", String.Empty);
            }
            return hash;
        }

        public static bool IsValid(string password)
        {
            if (String.IsNullOrEmpty(password))
            {
                return false;
            }
            string hashToCompare = GetHash(password);
            return IsValidHash(hashToCompare);
        }

        public static bool IsValidHash(string hashToCompare) => hashToCompare == _hash.ToUpper();

    }
}
