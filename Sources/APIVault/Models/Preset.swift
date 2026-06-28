import SwiftUI

enum PresetCategory: String, CaseIterable, Identifiable {
    case ai = "AI"
    case code = "Code"
    case payments = "Payments"
    case cloud = "Cloud"
    case data = "Data"
    case communications = "Comms"
    case monitoring = "Monitoring"
    case custom = "Custom"

    var id: String { rawValue }
}

enum PresetAccent: String, CaseIterable, Identifiable, Sendable {
    case blue
    case green
    case orange
    case purple
    case rose
    case gray

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .blue: .blue
        case .green: .green
        case .orange: .orange
        case .purple: .purple
        case .rose: .pink
        case .gray: .secondary
        }
    }
}

struct Preset: Identifiable, Hashable, Sendable {
    let id: String
    let serviceName: String
    let environmentVariable: String
    let symbolName: String
    let iconAssetName: String
    let accent: PresetAccent
    let category: PresetCategory
    let keyHint: String

    var maskedValue: String { String(repeating: "•", count: 12) }
    var exportTemplate: String { "export \(environmentVariable)=\"\(maskedValue)\"" }

    static let defaults: [Preset] = [
        Preset(
            id: "openai",
            serviceName: "OpenAI",
            environmentVariable: "OPENAI_API_KEY",
            symbolName: "sparkles",
            iconAssetName: "openai",
            accent: .green,
            category: .ai,
            keyHint: "sk-..."
        ),
        Preset(
            id: "anthropic",
            serviceName: "Anthropic",
            environmentVariable: "ANTHROPIC_API_KEY",
            symbolName: "brain.head.profile",
            iconAssetName: "anthropic",
            accent: .orange,
            category: .ai,
            keyHint: "sk-ant-..."
        ),
        Preset(
            id: "openrouter",
            serviceName: "OpenRouter",
            environmentVariable: "OPENROUTER_API_KEY",
            symbolName: "arrow.triangle.branch",
            iconAssetName: "openrouter",
            accent: .purple,
            category: .ai,
            keyHint: "sk-or-..."
        ),
        Preset(
            id: "gemini",
            serviceName: "Google Gemini",
            environmentVariable: "GEMINI_API_KEY",
            symbolName: "sparkle.magnifyingglass",
            iconAssetName: "gemini",
            accent: .blue,
            category: .ai,
            keyHint: "AIza..."
        ),
        Preset(
            id: "azure-openai",
            serviceName: "Azure OpenAI",
            environmentVariable: "AZURE_OPENAI_API_KEY",
            symbolName: "cloud.fill",
            iconAssetName: "azure-openai",
            accent: .blue,
            category: .ai,
            keyHint: "Paste Azure OpenAI key"
        ),
        Preset(
            id: "mistral",
            serviceName: "Mistral",
            environmentVariable: "MISTRAL_API_KEY",
            symbolName: "wind",
            iconAssetName: "mistral",
            accent: .orange,
            category: .ai,
            keyHint: "Paste Mistral key"
        ),
        Preset(
            id: "cohere",
            serviceName: "Cohere",
            environmentVariable: "COHERE_API_KEY",
            symbolName: "circle.hexagongrid",
            iconAssetName: "cohere",
            accent: .green,
            category: .ai,
            keyHint: "Paste Cohere key"
        ),
        Preset(
            id: "xai",
            serviceName: "xAI",
            environmentVariable: "XAI_API_KEY",
            symbolName: "xmark",
            iconAssetName: "xai",
            accent: .gray,
            category: .ai,
            keyHint: "xai-..."
        ),
        Preset(
            id: "perplexity",
            serviceName: "Perplexity",
            environmentVariable: "PERPLEXITY_API_KEY",
            symbolName: "p.circle",
            iconAssetName: "perplexity",
            accent: .blue,
            category: .ai,
            keyHint: "pplx-..."
        ),
        Preset(
            id: "groq",
            serviceName: "Groq",
            environmentVariable: "GROQ_API_KEY",
            symbolName: "bolt.fill",
            iconAssetName: "groq",
            accent: .orange,
            category: .ai,
            keyHint: "gsk_..."
        ),
        Preset(
            id: "deepseek",
            serviceName: "DeepSeek",
            environmentVariable: "DEEPSEEK_API_KEY",
            symbolName: "magnifyingglass",
            iconAssetName: "deepseek",
            accent: .blue,
            category: .ai,
            keyHint: "sk-..."
        ),
        Preset(
            id: "together",
            serviceName: "Together AI",
            environmentVariable: "TOGETHER_API_KEY",
            symbolName: "person.3.fill",
            iconAssetName: "together",
            accent: .purple,
            category: .ai,
            keyHint: "Paste Together key"
        ),
        Preset(
            id: "replicate",
            serviceName: "Replicate",
            environmentVariable: "REPLICATE_API_TOKEN",
            symbolName: "square.stack.3d.up",
            iconAssetName: "replicate",
            accent: .gray,
            category: .ai,
            keyHint: "r8_..."
        ),
        Preset(
            id: "huggingface",
            serviceName: "Hugging Face",
            environmentVariable: "HUGGINGFACE_API_TOKEN",
            symbolName: "face.smiling",
            iconAssetName: "huggingface",
            accent: .orange,
            category: .ai,
            keyHint: "hf_..."
        ),
        Preset(
            id: "github",
            serviceName: "GitHub",
            environmentVariable: "GITHUB_TOKEN",
            symbolName: "chevron.left.forwardslash.chevron.right",
            iconAssetName: "github",
            accent: .gray,
            category: .code,
            keyHint: "ghp_..."
        ),
        Preset(
            id: "gitlab",
            serviceName: "GitLab",
            environmentVariable: "GITLAB_TOKEN",
            symbolName: "chevron.left.forwardslash.chevron.right",
            iconAssetName: "gitlab",
            accent: .orange,
            category: .code,
            keyHint: "glpat-..."
        ),
        Preset(
            id: "bitbucket",
            serviceName: "Bitbucket",
            environmentVariable: "BITBUCKET_TOKEN",
            symbolName: "shippingbox",
            iconAssetName: "bitbucket",
            accent: .blue,
            category: .code,
            keyHint: "Paste Bitbucket token"
        ),
        Preset(
            id: "linear",
            serviceName: "Linear",
            environmentVariable: "LINEAR_API_KEY",
            symbolName: "line.3.horizontal.decrease",
            iconAssetName: "linear",
            accent: .purple,
            category: .code,
            keyHint: "lin_api_..."
        ),
        Preset(
            id: "jira",
            serviceName: "Jira",
            environmentVariable: "JIRA_API_TOKEN",
            symbolName: "checklist",
            iconAssetName: "jira",
            accent: .blue,
            category: .code,
            keyHint: "Paste Jira token"
        ),
        Preset(
            id: "vercel",
            serviceName: "Vercel",
            environmentVariable: "VERCEL_TOKEN",
            symbolName: "triangle.fill",
            iconAssetName: "vercel",
            accent: .gray,
            category: .code,
            keyHint: "Paste Vercel token"
        ),
        Preset(
            id: "netlify",
            serviceName: "Netlify",
            environmentVariable: "NETLIFY_AUTH_TOKEN",
            symbolName: "bolt.horizontal.circle",
            iconAssetName: "netlify",
            accent: .green,
            category: .code,
            keyHint: "nfp_..."
        ),
        Preset(
            id: "npm",
            serviceName: "npm",
            environmentVariable: "NPM_TOKEN",
            symbolName: "cube.box",
            iconAssetName: "npm",
            accent: .rose,
            category: .code,
            keyHint: "npm_..."
        ),
        Preset(
            id: "docker",
            serviceName: "Docker Hub",
            environmentVariable: "DOCKER_TOKEN",
            symbolName: "shippingbox.fill",
            iconAssetName: "docker",
            accent: .blue,
            category: .code,
            keyHint: "dckr_pat_..."
        ),
        Preset(
            id: "stripe",
            serviceName: "Stripe",
            environmentVariable: "STRIPE_API_KEY",
            symbolName: "creditcard",
            iconAssetName: "stripe",
            accent: .blue,
            category: .payments,
            keyHint: "sk_live_..."
        ),
        Preset(
            id: "paypal",
            serviceName: "PayPal",
            environmentVariable: "PAYPAL_CLIENT_SECRET",
            symbolName: "p.circle.fill",
            iconAssetName: "paypal",
            accent: .blue,
            category: .payments,
            keyHint: "Paste PayPal secret"
        ),
        Preset(
            id: "square",
            serviceName: "Square",
            environmentVariable: "SQUARE_ACCESS_TOKEN",
            symbolName: "square.fill",
            iconAssetName: "square",
            accent: .gray,
            category: .payments,
            keyHint: "EAA..."
        ),
        Preset(
            id: "adyen",
            serviceName: "Adyen",
            environmentVariable: "ADYEN_API_KEY",
            symbolName: "a.circle.fill",
            iconAssetName: "adyen",
            accent: .green,
            category: .payments,
            keyHint: "AQE..."
        ),
        Preset(
            id: "braintree",
            serviceName: "Braintree",
            environmentVariable: "BRAINTREE_PRIVATE_KEY",
            symbolName: "b.circle.fill",
            iconAssetName: "braintree",
            accent: .blue,
            category: .payments,
            keyHint: "Paste Braintree key"
        ),
        Preset(
            id: "paddle",
            serviceName: "Paddle",
            environmentVariable: "PADDLE_API_KEY",
            symbolName: "p.circle",
            iconAssetName: "paddle",
            accent: .purple,
            category: .payments,
            keyHint: "pdl_..."
        ),
        Preset(
            id: "lemon-squeezy",
            serviceName: "Lemon Squeezy",
            environmentVariable: "LEMONSQUEEZY_API_KEY",
            symbolName: "leaf.fill",
            iconAssetName: "lemon-squeezy",
            accent: .orange,
            category: .payments,
            keyHint: "eyJ..."
        ),
        Preset(
            id: "revenuecat",
            serviceName: "RevenueCat",
            environmentVariable: "REVENUECAT_API_KEY",
            symbolName: "chart.line.uptrend.xyaxis",
            iconAssetName: "revenuecat",
            accent: .purple,
            category: .payments,
            keyHint: "rc_..."
        ),
        Preset(
            id: "aws",
            serviceName: "AWS",
            environmentVariable: "AWS_SECRET_ACCESS_KEY",
            symbolName: "cloud.fill",
            iconAssetName: "aws",
            accent: .orange,
            category: .cloud,
            keyHint: "Paste AWS secret"
        ),
        Preset(
            id: "google-cloud",
            serviceName: "Google Cloud",
            environmentVariable: "GOOGLE_CLOUD_API_KEY",
            symbolName: "cloud.fill",
            iconAssetName: "google-cloud",
            accent: .blue,
            category: .cloud,
            keyHint: "AIza..."
        ),
        Preset(
            id: "azure",
            serviceName: "Azure",
            environmentVariable: "AZURE_API_KEY",
            symbolName: "cloud.fill",
            iconAssetName: "azure",
            accent: .blue,
            category: .cloud,
            keyHint: "Paste Azure key"
        ),
        Preset(
            id: "cloudflare",
            serviceName: "Cloudflare",
            environmentVariable: "CLOUDFLARE_API_TOKEN",
            symbolName: "cloud.sun.fill",
            iconAssetName: "cloudflare",
            accent: .orange,
            category: .cloud,
            keyHint: "Paste Cloudflare token"
        ),
        Preset(
            id: "digitalocean",
            serviceName: "DigitalOcean",
            environmentVariable: "DIGITALOCEAN_ACCESS_TOKEN",
            symbolName: "drop.fill",
            iconAssetName: "digitalocean",
            accent: .blue,
            category: .cloud,
            keyHint: "dop_v1_..."
        ),
        Preset(
            id: "heroku",
            serviceName: "Heroku",
            environmentVariable: "HEROKU_API_KEY",
            symbolName: "h.circle.fill",
            iconAssetName: "heroku",
            accent: .purple,
            category: .cloud,
            keyHint: "Paste Heroku key"
        ),
        Preset(
            id: "render",
            serviceName: "Render",
            environmentVariable: "RENDER_API_KEY",
            symbolName: "r.circle.fill",
            iconAssetName: "render",
            accent: .gray,
            category: .cloud,
            keyHint: "rnd_..."
        ),
        Preset(
            id: "fly",
            serviceName: "Fly.io",
            environmentVariable: "FLY_API_TOKEN",
            symbolName: "paperplane.fill",
            iconAssetName: "fly",
            accent: .purple,
            category: .cloud,
            keyHint: "FlyV1 ..."
        ),
        Preset(
            id: "supabase",
            serviceName: "Supabase",
            environmentVariable: "SUPABASE_SERVICE_ROLE_KEY",
            symbolName: "bolt.fill",
            iconAssetName: "supabase",
            accent: .green,
            category: .data,
            keyHint: "eyJ..."
        ),
        Preset(
            id: "firebase",
            serviceName: "Firebase",
            environmentVariable: "FIREBASE_API_KEY",
            symbolName: "flame.fill",
            iconAssetName: "firebase",
            accent: .orange,
            category: .data,
            keyHint: "AIza..."
        ),
        Preset(
            id: "mongodb",
            serviceName: "MongoDB Atlas",
            environmentVariable: "MONGODB_API_KEY",
            symbolName: "leaf.fill",
            iconAssetName: "mongodb",
            accent: .green,
            category: .data,
            keyHint: "Paste MongoDB key"
        ),
        Preset(
            id: "planetscale",
            serviceName: "PlanetScale",
            environmentVariable: "PLANETSCALE_SERVICE_TOKEN",
            symbolName: "circle.grid.cross",
            iconAssetName: "planetscale",
            accent: .gray,
            category: .data,
            keyHint: "pscale_tkn_..."
        ),
        Preset(
            id: "neon",
            serviceName: "Neon",
            environmentVariable: "NEON_API_KEY",
            symbolName: "n.circle.fill",
            iconAssetName: "neon",
            accent: .green,
            category: .data,
            keyHint: "Paste Neon key"
        ),
        Preset(
            id: "redis",
            serviceName: "Redis",
            environmentVariable: "REDIS_PASSWORD",
            symbolName: "square.stack.3d.down.right.fill",
            iconAssetName: "redis",
            accent: .rose,
            category: .data,
            keyHint: "Paste Redis password"
        ),
        Preset(
            id: "pinecone",
            serviceName: "Pinecone",
            environmentVariable: "PINECONE_API_KEY",
            symbolName: "p.circle.fill",
            iconAssetName: "pinecone",
            accent: .green,
            category: .data,
            keyHint: "pcsk_..."
        ),
        Preset(
            id: "algolia",
            serviceName: "Algolia",
            environmentVariable: "ALGOLIA_API_KEY",
            symbolName: "magnifyingglass.circle.fill",
            iconAssetName: "algolia",
            accent: .blue,
            category: .data,
            keyHint: "Paste Algolia key"
        ),
        Preset(
            id: "twilio",
            serviceName: "Twilio",
            environmentVariable: "TWILIO_AUTH_TOKEN",
            symbolName: "phone.fill",
            iconAssetName: "twilio",
            accent: .rose,
            category: .communications,
            keyHint: "Paste Twilio token"
        ),
        Preset(
            id: "sendgrid",
            serviceName: "SendGrid",
            environmentVariable: "SENDGRID_API_KEY",
            symbolName: "paperplane.fill",
            iconAssetName: "sendgrid",
            accent: .blue,
            category: .communications,
            keyHint: "SG..."
        ),
        Preset(
            id: "mailgun",
            serviceName: "Mailgun",
            environmentVariable: "MAILGUN_API_KEY",
            symbolName: "envelope.fill",
            iconAssetName: "mailgun",
            accent: .orange,
            category: .communications,
            keyHint: "key-..."
        ),
        Preset(
            id: "resend",
            serviceName: "Resend",
            environmentVariable: "RESEND_API_KEY",
            symbolName: "arrow.uturn.forward",
            iconAssetName: "resend",
            accent: .gray,
            category: .communications,
            keyHint: "re_..."
        ),
        Preset(
            id: "postmark",
            serviceName: "Postmark",
            environmentVariable: "POSTMARK_SERVER_TOKEN",
            symbolName: "envelope.badge.fill",
            iconAssetName: "postmark",
            accent: .blue,
            category: .communications,
            keyHint: "Paste Postmark token"
        ),
        Preset(
            id: "slack",
            serviceName: "Slack",
            environmentVariable: "SLACK_BOT_TOKEN",
            symbolName: "number",
            iconAssetName: "slack",
            accent: .purple,
            category: .communications,
            keyHint: "xoxb-..."
        ),
        Preset(
            id: "discord",
            serviceName: "Discord",
            environmentVariable: "DISCORD_BOT_TOKEN",
            symbolName: "gamecontroller.fill",
            iconAssetName: "discord",
            accent: .purple,
            category: .communications,
            keyHint: "Paste Discord token"
        ),
        Preset(
            id: "sentry",
            serviceName: "Sentry",
            environmentVariable: "SENTRY_AUTH_TOKEN",
            symbolName: "exclamationmark.triangle.fill",
            iconAssetName: "sentry",
            accent: .purple,
            category: .monitoring,
            keyHint: "sntrys_..."
        ),
        Preset(
            id: "datadog",
            serviceName: "Datadog",
            environmentVariable: "DATADOG_API_KEY",
            symbolName: "waveform.path.ecg",
            iconAssetName: "datadog",
            accent: .purple,
            category: .monitoring,
            keyHint: "Paste Datadog key"
        ),
        Preset(
            id: "newrelic",
            serviceName: "New Relic",
            environmentVariable: "NEW_RELIC_LICENSE_KEY",
            symbolName: "chart.xyaxis.line",
            iconAssetName: "newrelic",
            accent: .green,
            category: .monitoring,
            keyHint: "Paste New Relic key"
        ),
        Preset(
            id: "custom",
            serviceName: "Custom",
            environmentVariable: "CUSTOM_API_KEY",
            symbolName: "key",
            iconAssetName: "",
            accent: .rose,
            category: .custom,
            keyHint: "Paste any developer secret"
        )
    ]
}
