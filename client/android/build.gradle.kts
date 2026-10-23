allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Flutter plugins are compiled from source as subprojects, and Android
// modules default to Java 8 bytecode — that's what triggers the
// "source value 8 is obsolete" javac warnings. Align every Android module
// on Java 17 / Kotlin JVM 17 to match this app's own compileOptions.
subprojects {
    fun Project.alignBytecodeTo17() {
        val androidExt = extensions.findByName("android") ?: return

        // Java compileOptions → 17
        runCatching {
            val compileOptions = androidExt.javaClass.methods
                .first { it.name == "getCompileOptions" }
                .invoke(androidExt)
            val java17 = JavaVersion.VERSION_17
            compileOptions.javaClass.methods
                .first { it.name == "setSourceCompatibility" }
                .invoke(compileOptions, java17)
            compileOptions.javaClass.methods
                .first { it.name == "setTargetCompatibility" }
                .invoke(compileOptions, java17)
        }.onFailure {
            logger.info("skip java17 on ${project.name}: $it")
        }

        // Kotlin jvmTarget → 17 (must stay consistent with the Java target)
        runCatching {
            val kotlinExt = extensions.findByName("kotlin") ?: return@runCatching
            val compilerOptions = kotlinExt.javaClass.methods
                .firstOrNull { it.name == "getCompilerOptions" }
                ?.invoke(kotlinExt) ?: return@runCatching
            val jvmTargetProp = compilerOptions.javaClass.methods
                .first { it.name == "getJvmTarget" }
                .invoke(compilerOptions)
            val jvm17 = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
            val setter = jvmTargetProp.javaClass.methods.first {
                it.name == "set" &&
                    it.parameterCount == 1 &&
                    it.parameterTypes[0].isInstance(jvm17)
            }
            setter.invoke(jvmTargetProp, jvm17)
        }.onFailure {
            logger.info("skip kotlin17 on ${project.name}: $it")
        }
    }

    try {
        afterEvaluate { alignBytecodeTo17() }
    } catch (e: RuntimeException) {
        // Flutter's Gradle plugin can fully evaluate plugin subprojects
        // during :app configuration; configure those immediately instead.
        println("ALREADY-EVALUATED subproject ${project.name} (${e.message}) — applying immediately")
        alignBytecodeTo17()
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
