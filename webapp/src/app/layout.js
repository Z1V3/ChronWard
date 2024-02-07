import { Inter } from "next/font/google";
import Providers from "../utils/provider";
import { GoogleOAuthProvider } from '@react-oauth/google';
import "./style.css";

const inter = Inter({ subsets: ["latin"] });

export const metadata = {
  title: "EVCharge",
  description: "Generated by create next app",
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <GoogleOAuthProvider clientId="855876363690-3ba2r2a2aed4lerj4tm115oufnhq7shc.apps.googleusercontent.com">
        <Providers>
          <body className={inter.className}>{children}</body>
        </Providers>
      </GoogleOAuthProvider>;
      
    </html>
  );
}
