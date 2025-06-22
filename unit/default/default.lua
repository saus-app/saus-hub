-- unit.default
users.default = defaultUser({
    name = "Saus User",
});

envs.personal = env({
    name = "Personal",
    description = "A private space to experiment and create things just for you.",
    icon = "personal",
    owner = users.default,
});

envs.production = env({
    name = "Production",
    description = "Important things that are in use and shouldn't break.",
    icon = "production",
    owner = users.default,
});

envs.sandbox = env({
    name = "Sandbox",
    description = "A space to create and test new things, by yourself or with others.",
    icon = "sandbox",
    owner = users.default,
});