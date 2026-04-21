allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

// Fix for plugins that don't specify compileSdk
subprojects {
    plugins.withId("com.android.library") {
        val android = extensions.getByType(com.android.build.gradle.LibraryExtension::class.java)
        android.compileSdk = android.compileSdk ?: 34
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
