"use client"
import SignUp from "@/components/SignUp/SignUp";
import { useLocalStorage } from "@uidotdev/usehooks";
import {useEffect} from 'react';


export default function Register() {
  const [user, saveUser] = useLocalStorage("user", null);

  useEffect(() => {
    if(user) {
      window.location.href = "/"
    }
  }, [user])


  return (
    <main>
      <SignUp />
    </main>
  );
}
