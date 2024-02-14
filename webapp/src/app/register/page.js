"use client";
import SignUp from "@/components/SignUp/SignUp";
import { useLocalStorage } from "@uidotdev/usehooks";
import { useRouter } from "next/navigation";
import { useEffect } from "react";

export default function Register() {
  const [user, saveUser] = useLocalStorage("user", null);
  const router = useRouter();

  useEffect(() => {
    if (user) {
      router.replace("/");
    }
  }, [router, user]);

  return (
    <main>
      <SignUp />
    </main>
  );
}
