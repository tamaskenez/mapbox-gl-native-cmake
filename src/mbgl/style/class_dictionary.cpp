#include <mbgl/style/class_dictionary.hpp>

#include <uv.h>

#include <boost/thread/tss.hpp>

namespace mbgl {

ClassDictionary::ClassDictionary() {}

ClassDictionary &ClassDictionary::Get() {
    // Note: We should eventually switch to uv_key_* functions, but libuv 0.10 doesn't have these
    // yet. Instead, we're using the pthread functions directly for now.
    static boost::thread_specific_ptr<ClassDictionary> store_key(
        [](ClassDictionary *ptr) {
            delete ptr;
        }
    );

    ClassDictionary *ptr = store_key.get();
    if (ptr == nullptr) {
        ptr = new ClassDictionary();
        store_key.reset(ptr);
    }

    return *ptr;
}

ClassID ClassDictionary::lookup(const std::string &class_name) {
    auto it = store.find(class_name);
    if (it == store.end()) {
        // Insert the class name into the store.
        ClassID id = ClassID(uint32_t(ClassID::Named) + offset++);
        store.emplace(class_name, id);
        return id;
    } else {
        return it->second;
    }
}

ClassID ClassDictionary::normalize(ClassID id) {
    if (id >= ClassID::Named) {
        return ClassID::Named;
    } else {
        return id;
    }
}

}
