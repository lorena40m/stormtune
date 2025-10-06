"use client";
import { motion } from "framer-motion";
import Image from "next/image";

export default function Home() {
	return (
		<div className="min-h-screen bg-background text-foreground">
			<header className="container mx-auto flex items-center justify-between px-6 py-6">
				<div className="flex items-center gap-2">
					<Image src="/logo.png" alt="StormTune" width={32} height={32} className="dark:invert" />
					<span className="text-lg font-semibold tracking-tight">StormTune</span>
				</div>
				<nav className="hidden md:flex items-center gap-6 text-sm">
					<a href="#features" className="hover:opacity-80 transition-opacity">Features</a>
					<a href="#how" className="hover:opacity-80 transition-opacity">How it works</a>
					<a href="#cta" className="hover:opacity-80 transition-opacity">Get started</a>
				</nav>
			</header>

			<main className="container mx-auto px-6">
				<section className="grid md:grid-cols-2 gap-10 items-center py-16 md:py-24">
					<div>
						<motion.h1
							initial={{ opacity: 0, y: 20 }}
							animate={{ opacity: 1, y: 0 }}
							transition={{ duration: 0.6 }}
							className="text-4xl md:text-6xl font-bold tracking-tight"
						>
							Unlock Peak Performance, Any Weather
						</motion.h1>
						<motion.p
							initial={{ opacity: 0, y: 20 }}
							animate={{ opacity: 1, y: 0 }}
							transition={{ duration: 0.6, delay: 0.1 }}
							className="mt-5 text-lg md:text-xl text-muted-foreground max-w-[60ch]"
						>
							Real-time tuning recommendations powered by live weather data and your car profile.
						</motion.p>

						<motion.div
							initial={{ opacity: 0, y: 20 }}
							animate={{ opacity: 1, y: 0 }}
							transition={{ duration: 0.6, delay: 0.2 }}
							className="mt-8 flex items-center gap-4"
						>
							<a
								href="#cta"
								className="inline-flex items-center rounded-full bg-primary text-primary-foreground px-6 py-3 text-sm font-medium shadow-sm hover:opacity-90 transition"
							>
								Get started
							</a>
							<a
								href="#features"
								className="inline-flex items-center rounded-full border px-6 py-3 text-sm font-medium hover:bg-secondary transition"
							>
								Learn more
							</a>
						</motion.div>
					</div>

					<div className="relative">
						<motion.div
							initial={{ opacity: 0, scale: 0.96 }}
							animate={{ opacity: 1, scale: 1 }}
							transition={{ duration: 0.6, delay: 0.15 }}
							className="rounded-xl border bg-card text-card-foreground shadow-sm p-6"
						>
							<div className="grid grid-cols-2 gap-4">
								<div className="rounded-md bg-secondary p-4">
									<p className="text-sm text-muted-foreground">Current Weather</p>
									<p className="mt-2 text-2xl font-semibold">22°C • 40% RH</p>
								</div>
								<div className="rounded-md bg-secondary p-4">
									<p className="text-sm text-muted-foreground">Track</p>
									<p className="mt-2 text-2xl font-semibold">Silverstone</p>
								</div>
								<div className="rounded-md bg-secondary p-4">
									<p className="text-sm text-muted-foreground">Spark Gap</p>
									<p className="mt-2 text-2xl font-semibold">0.028" → 0.030"</p>
								</div>
								<div className="rounded-md bg-secondary p-4">
									<p className="text-sm text-muted-foreground">Race Mode</p>
									<p className="mt-2 text-2xl font-semibold">Time Attack</p>
								</div>
							</div>
						</motion.div>

						<motion.div
							initial="hidden"
							animate="show"
							variants={{ hidden: {}, show: { transition: { staggerChildren: 0.08 } } }}
							className="mt-6 grid grid-cols-3 gap-3"
						>
							{["Air Temp", "Humidity", "Altitude"].map((label, i) => (
								<motion.div
									key={label}
									initial={{ opacity: 0, y: 8 }}
									animate={{ opacity: 1, y: 0 }}
									transition={{ duration: 0.4, delay: 0.2 + i * 0.05 }}
									className="rounded-md border p-3 text-sm text-muted-foreground"
								>
									{label}
								</motion.div>
							))}
						</motion.div>
					</div>
				</section>

				<section id="features" className="py-12 md:py-16">
					<div className="grid md:grid-cols-3 gap-6">
						{[
							{ title: "Live Weather", desc: "Fetches localized conditions for accurate recommendations." },
							{ title: "Profiles", desc: "Save car setups and switch per track or mode." },
							{ title: "Smart Tuning", desc: "Get spark gap and more tuned to conditions." },
						].map((f, idx) => (
							<motion.div
								key={f.title}
								initial={{ opacity: 0, y: 12 }}
								whileInView={{ opacity: 1, y: 0 }}
								viewport={{ once: true, amount: 0.3 }}
								transition={{ duration: 0.45, delay: idx * 0.05 }}
								className="rounded-xl border p-6 bg-card"
							>
								<h3 className="text-lg font-semibold">{f.title}</h3>
								<p className="mt-2 text-sm text-muted-foreground">{f.desc}</p>
							</motion.div>
						))}
					</div>
				</section>

				<section id="cta" className="py-12 md:py-20 text-center">
					<motion.h2
						initial={{ opacity: 0, y: 8 }}
						whileInView={{ opacity: 1, y: 0 }}
						viewport={{ once: true }}
						transition={{ duration: 0.4 }}
						className="text-3xl md:text-4xl font-bold"
					>
						Ready to tune smarter?
					</motion.h2>
					<motion.p
						initial={{ opacity: 0 }}
						whileInView={{ opacity: 1 }}
						viewport={{ once: true }}
						transition={{ duration: 0.4, delay: 0.1 }}
						className="mt-3 text-muted-foreground"
					>
						Open the app and create your first profile.
					</motion.p>
					<motion.div
						initial={{ opacity: 0 }}
						whileInView={{ opacity: 1 }}
						viewport={{ once: true }}
						transition={{ duration: 0.4, delay: 0.2 }}
						className="mt-6"
					>
						<a href="/" className="inline-flex items-center rounded-full bg-primary text-primary-foreground px-6 py-3 text-sm font-medium shadow-sm hover:opacity-90 transition">
							Launch StormTune
						</a>
					</motion.div>
				</section>
			</main>

			<footer className="container mx-auto px-6 py-10 text-sm text-muted-foreground">
				<p>© {new Date().getFullYear()} StormTune. All rights reserved.</p>
			</footer>
		</div>
	);
}
